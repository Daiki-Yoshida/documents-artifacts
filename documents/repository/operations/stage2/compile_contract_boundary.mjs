/** Compile the working Stage 2 philosophy draft into an anonymous, standalone review file.
 * Authoritative editing input: A3_PHILOSOPHY_DRAFT.md.
 * Generated review output: review-export/CONTRACT_BOUNDARY_PHILOSOPHY.md.
 * No third-party packages required (Node.js standard library only).
 * Run from any directory: node <this-file> [--check|--stdout|--self-test].
 * Provenance and approval status remain in the surrounding Stage 2 records, never in output.
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

function compileContractBoundary(text) {
  if(typeof text!=="string"||!text.trim())throw Error("Empty input");
  const src=text.replace(/\r\n/g,"\n");
  function at(mark){const i=src.indexOf(mark);if(i<0||i!==src.lastIndexOf(mark))throw Error("Source marker missing or repeated: "+mark);return i;}
  at("# 契約境界哲学体系 — 編集用草案");
  const ch1=at('<a id="chapter-1"></a>'),end=at("## 次の編集のために");
  const scopeStart=at("本体系が扱うのは、"),scopeEnd=src.indexOf("\n\n",scopeStart);
  const toc=at("## 全体構成"),philosophyAnchor=at('<a id="philosophy-scope"></a>');
  const philosophyHeading=at("### 契約境界哲学体系の普遍階層と方法論");
  if(!(scopeStart<scopeEnd&&scopeEnd<toc&&toc<philosophyAnchor&&philosophyAnchor<philosophyHeading&&philosophyHeading<ch1&&ch1<end))throw Error("Source sections changed order");
  const intro=src.slice(scopeStart,scopeEnd).trim();
  const map=src.slice(toc,philosophyAnchor);
  const tab=map.indexOf("| 章 |"),explanation=map.indexOf("六章は説明上の構成であり");
  if(tab<0||explanation<0||tab>=explanation)throw Error("Chapter table missing");
  const table=map.slice(tab,explanation).trim().replace(/\[([^\]]+)\]\(#[^)]+\)/g,"$1");
  if((table.match(/^\| [1-6]．/gm)||[]).length!==6)throw Error("Chapter table changed");
  const note=map.slice(explanation).trim().replace("章構成自体も今後の検討対象に含む。","").trim();
  if(note.includes("今後の検討対象")||!note.includes("六つの工程ではない"))throw Error("Chapter explanation changed");
  let scope=src.slice(philosophyHeading,ch1).trim();
  const sourceNote="\n\nこの範囲の基礎はOwnerの";
  if(!scope.includes(sourceNote))throw Error("Scope provenance changed");
  scope=scope.slice(0,scope.indexOf(sourceNote)).replace(/^### 契約境界哲学体系の普遍階層と方法論/,"## 本体系と開発方法論").trim();
  let body=src.slice(ch1,end);
  const chapters=[...body.matchAll(/^<a id="chapter-(\d)"><\/a>$/gm)].map(m=>m[1]);
  const sections=[...body.matchAll(/^<a id="d([1-6])-([1-9])"><\/a>$/gm)].map(m=>m[1]+"."+m[2]);
  if(chapters.join(",")!=="1,2,3,4,5,6"||sections.length!==23||new Set(sections).size!==23)throw Error("Expected six chapters and 23 sections");
  if((body.match(/^出典：/gm)||[]).length!==7)throw Error("Unexpected provenance count");
  body=body.replace(/^出典：.*(?:\n|$)/gm,"")
           .replace(/^<a id="(?:chapter-[1-6]|d[1-6]-[1-9])"><\/a>\n/gm,"")
           .replace(/\[([^\]\n]+)\]\(#[^)]+\)/g,"$1");
  const neutral=[
    ["Ownerの数値例では、1000がマクロ側、100がミクロ側の壁である。","数値例では、1000がマクロ側、100がミクロ側の壁である。"],
    ["Ownerが示したA/B/Cの分類は、","A/B/Cの分類は、"],
    ["ここでの「委譲・依存」はOwnerが双璧を説明した文脈の語である。","ここでいう「委譲・依存」は、作業委託という一種類の関係に限定されない。"],
    ["この再帰性を本対話ではフラクタル性と呼ぶ。","この再帰性をここではフラクタル性と呼ぶ。"],
    ["また、再定義を修正不能な場合だけに限定する順序も、この段階では制定していない。","また、再定義を修正不能な場合だけに限定する順序も、本体系では定めない。"]
  ];
  for(const [a,b] of neutral){if(body.split(a).length-1!==1)throw Error("Source wording changed: "+a);body=body.replace(a,b);}
  const output=["# 契約境界哲学体系",intro,"## 全体構成",table,note,scope,body.trim()].join("\n\n").replace(/\n{3,}/g,"\n\n").trim()+"\n";
  const leaks=[/Owner|Assistant|ChatGPT/,/出典：|Issue\s*#\d|S\d{2}\s*[UA]\d|A3_PHILOSOPHY|refactor\/dev-artifacts/,/未承認|編集用草案|本対話|次の編集のために|この段階では制定/,/<a id=/,/\[[^\]\n]+\]\([^)]+\)/,/https?:\/\//];
  for(let i=0;i<leaks.length;i++)if(leaks[i].test(output))throw Error("Anonymous output leakage #"+(i+1)+": "+output.match(leaks[i])[0]);
  if((output.match(/^## [1-6]．/gm)||[]).length!==6||(output.match(/^### D[1-6]\.[1-9] /gm)||[]).length!==23)throw Error("Compiled outline count incorrect");
  if(!output.includes("**契約の成立とは")||!output.includes("**契約の履行とは")||!output.includes("**契約による分割を既定として検討し"))throw Error("Important statements missing");
  return output;
}

const root=path.dirname(fileURLToPath(import.meta.url));
const sourcePath=path.join(root,"A3_PHILOSOPHY_DRAFT.md");
const outputPath=path.join(root,"review-export","CONTRACT_BOUNDARY_PHILOSOPHY.md");
const args=process.argv.slice(2);
if(args.length>1||(args[0]&&!["--check","--stdout","--self-test"].includes(args[0]))){
  process.stderr.write("Usage: node compile_contract_boundary.mjs [--check|--stdout|--self-test]\n");
  process.exitCode=2;
}else{
  try{
    const source=fs.readFileSync(sourcePath,"utf8");
    const compiled=compileContractBoundary(source);
    if(args[0]==="--check"){
      if(fs.readFileSync(outputPath,"utf8")!==compiled)throw Error("Review export is stale; regenerate first.");
      process.stdout.write("Review export is current.\n");
    }else if(args[0]==="--stdout"){
      process.stdout.write(compiled);
    }else if(args[0]==="--self-test"){
      if(compiled!==compileContractBoundary(source))throw Error("Nondeterministic compiler");
      function mustFail(mutated,what){let rejected=false;try{compileContractBoundary(mutated)}catch(e){rejected=true}if(!rejected)throw Error("Negative test failed: "+what);}
      mustFail(source.replace('<a id="chapter-6"></a>',''),"chapter");
      mustFail(source.replace("### D3.2 契約の成立","### D3.2 契約の成立\n\nOwnerが評価した。"),"identity");
      mustFail(source.replace("出典：S01 U2〜U8","脚注：S01 U2〜U8"),"provenance");
      process.stdout.write("Self-test passed.\n");
    }else{
      fs.mkdirSync(path.dirname(outputPath),{recursive:true});
      fs.writeFileSync(outputPath,compiled,"utf8");
      process.stdout.write("Generated: "+path.relative(root,outputPath)+"\n");
    }
  }catch(e){
    process.stderr.write("Compile failed: "+String(e.message||e)+"\n");
    process.exitCode=1;
  }
}
