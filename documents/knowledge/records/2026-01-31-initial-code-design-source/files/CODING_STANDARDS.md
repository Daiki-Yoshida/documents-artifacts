# Coding Standards & patterns - AI Agent Reference

```yaml
document_type: "coding_standards"
target_audience: "ai_agents"
language_context: "C#"
secondary_context: "TypeScript"
optimization: "implementation_accuracy"
```

## Interface Design Rules

Interfaces are the backbone of our architecture.

### Naming & Granularity
*   **Prefix**: MUST use `I` prefix (e.g., `IJobFetcher`).
*   **Granularity**: Cohesive Capability (not just Atomic)
    *   *Rule*: Group methods that change together for the same business reason.
    *   *Bad*: `IUserManager` (Create, Read, Update, Delete, Notify, Log) - Mixed concerns.
    *   *Bad*: `IUserCreator`, `IUserUpdater`, `IUserDeleter` - Fragmented cohesion (anti-pattern: "method-as-service").
    *   *Good*: `IUserRepository` (CRUD), `IUserNotifier` (Notification).

### Interface Segregation (ISP)
Clients should not be forced to depend on methods they do not use.

```csharp
// BAD: Fat Interface
interface ISmartDevice {
    void Print();
    void Scan();
    void Fax();
}

// GOOD: Segregated Interfaces
interface IPrinter { void Print(); }
interface IScanner { void Scan(); }
interface IFax { void Fax(); }

// Composition for convenience
interface IMultiFunctionDevice : IPrinter, IScanner, IFax { }
```

---

## Layered Architecture

Strict dependency flow: **App -> Infra -> Domain**.

### 1. Domain Layer (`src/Domain`)
*   **Contains**: Interfaces, Entities, Value Objects, Domain Errors.
*   **Dependencies**: ZERO dependencies on outer layers (Infra/App).
*   **Style**: Pure C# classes/interfaces.

### 2. Infrastructure Layer (`src/Infrastructure`)
*   **Contains**: Concrete implementations (Database access, API clients, File IO).
*   **Dependencies**: Depends on **Domain**.
*   **Role**: "How" technical details are executed.

### 3. Application Layer (`src/Application`)
*   **Contains**: Use Cases, Services, Orchestration.
*   **Dependencies**: Depends on **Domain** interfaces.
*   **Role**: High-level flow control. Receives concrete Infra implementations via DI.
*   **Boundary Rule**: MUST define its own Request/Response DTOs. NEVER expose Domain Entities directly to external boundaries (API/CLI).

### Type Placement Guidelines
| Type | Layer | Purpose |
| :--- | :--- | :--- |
| **Domain Entity/ValueObject** | Domain | Business rules, Invariants |
| **UseCase DTO (Request/Response)** | Application | Boundary data transfer, UI/API formatting |
| **Tech DTO (DbModel/ApiSchema)** | Infrastructure | Storage/Network serialization format |

**Rule**: Application Layer handles mapping between Domain Entities and Boundary DTOs. Infrastructure handles mapping between Domain Entities and Tech DTOs.

---

## Dependency Injection (DI)

### Connector Injection Only
All dependencies MUST be provided via the constructor.

```csharp
public class JobSyncService {
    private readonly IJobFetcher _fetcher;
    private readonly IJobStore _store;

    // Explicit dependencies
    public JobSyncService(IJobFetcher fetcher, IJobStore store) {
        _fetcher = fetcher;
        _store = store;
    }
}
```

*   **No Service Locator**: Do not use `Container.Resolve<T>()` inside classes.
*   **Volatile Dependencies**: Do not instantiate volatile dependencies (IO, Config, Random, Time) with `new`. Use DI.
*   **Stable Dependencies**: You MAY use `new` for Value Objects, Entities, and Pure Utility classes.

---

## Error Handling Strategy

Distinguish between "Expected Business Logic Deviations" and "System Failures".

### Pattern A: Result Pattern (Preferred for Logic)
Use when the caller needs to handle simple failure cases (e.g., "Not Found", "Validation Failed") explicitly.

**Constraint**: The Error type `E` MUST be a discriminated union or enum. It MUST NOT be a string or primitive exception.
**Constraint**: The Error type `E` MUST NOT contain UI text, localization, or log strings. It serves logic branching only.

```csharp
// E is a specific Enum or Discriminated Union
public enum UserError { NotFound, AlreadyExists, InvalidEmail }

```csharp
// Return a Result<T, E> type
public async Task<Result<User, UserError>> FindUserAsync(UserId id);

// Usage
var result = await repo.FindUserAsync(id);
if (result.IsSuccess) {
    HandleUser(result.Value);
} else {
    HandleError(result.Error); // Explicit branching
}
```

### Pattern B: Exceptions (Preferred for Infrastructure/Panics)
Use when the system cannot recover gracefully (e.g., "Database Down", "Out of Memory", "Configuration Missing").
*   Let it crash or be caught by a top-level global handler.
*   Do not use exceptions for control flow.

---

## Data Model Patterns

### 1. Rich Domain Model (Default)
Entities contain both state and behavior.

```csharp
public class Order {
    public List<LineItem> Items { get; private set; }
    public bool IsPaid { get; private set; }

    // Behavior encapsulates state mutation
    public void AddItem(Product product, int quantity) {
        if (IsPaid) throw new InvalidOperationException("Cannot modify paid order");
        Items.Add(new LineItem(product, quantity));
    }
}
```

### 2. Anemic Model + Service (Alternative)
Use ONLY when logic relies heavily on creating external dependencies that don't belong in the entity.
*   *Entity*: Pure data structure (POCO).
*   *Service*: Contains the logic.

---

## Testing Strategy

Write tests against **Interfaces**, not Implementations.

1.  **Mocking**: specific scenarios can be tested by injecting Mocks that implement domain interfaces.
2.  **No Logic in Mocks**: Mocks should return fixed data.
3.  **Test the Use Case**: Validate the orchestration logic in the Application layer.

```csharp
[Fact]
public async Task Sync_ShouldStoreJobs_WhenFetcherReturnsJobs() {
    // Arrange
    var mockFetcher = new Mock<IJobFetcher>();
    mockFetcher.Setup(f => f.FetchAsync()).ReturnsAsync(new[] { new Job("Job1") });
    
    var mockStore = new Mock<IJobStore>();
    
    var service = new JobSyncService(mockFetcher.Object, mockStore.Object);

    // Act
    await service.SyncAsync();

    // Assert
    mockStore.Verify(s => s.SaveAsync(It.Is<Job>(j => j.Title == "Job1")), Times.Once);
}
```

### Contract Testing (Required for Interfaces)
To prevent "MockDrift" (where mocks pass but real impl fails), every Domain Interface MUST have a Contract Test Suite.

1.  **Define Contract**: A test suite that runs against `TInterface`.
2.  **Verify Implementations**: All concrete implementations (Infra) MUST pass this suite.

```csharp
// The Contract (Abstract Test)
public abstract class JobStoreContractTests {
    protected abstract IJobStore CreateStore();

    [Fact]
    public async Task Save_ShouldPersistJob() {
        var store = CreateStore();
        var job = new Job("J1");
        await store.SaveAsync(job);
        var fetched = await store.GetAsync("J1");
        Assert.NotNull(fetched); // All impls must pass this behavior
    }
}
```
