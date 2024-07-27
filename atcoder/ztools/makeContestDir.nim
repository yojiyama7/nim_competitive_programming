import std/[os, sequtils, strutils, strformat, httpclient, json, tables, sets]
import zippy # zippyに感謝


const AllProblemUrl = "https://kenkoooo.com/atcoder/resources/merged-problems.json"
const LocalRoot = "../"
const TemplateProblemFilePrefixes = "abcdefg"
let basecodeText = open("basecode.nim").readAll()


proc isValidUrl(url: string): bool =
  url.startsWith("https://atcoder.jp/contests/")
var rawInputText = ""
while true:
  echo "enter url."
  rawInputText = stdin.readLine
  if rawInputText.len == 0:
    echo "length is 0."
    continue
  if rawInputText.isValidUrl:
    break
  echo "please valid atcoder url."
let inputUrl = rawInputText

var client = newHttpClient()
client.headers = newHttpHeaders({
  "Accept-Encoding": "gzip"
})
let
  res = client.request(AllProblemUrl)
  resString = zippy.uncompress(res.body)
let allProblems = parseJson(resString)
# for problem in allProblems:
#   echo problem

let problemsByContest = newTable[string, seq[JsonNode]]()
for problem in allProblems:
  let key = problem["contest_id"].getStr()
  if not problemsByContest.hasKey(key):
    problemsByContest[key] = newSeqWith(0, JsonNode())
  problemsByContest[key].add(problem)
# echo problemsByContest

proc mySplit(s: string, chars: HashSet[char]): seq[string] =
  var t = ""
  for c in s:
    if c in chars:
      result.add(t)
      t = ""
    else:
      t &= c
  result.add(t)
proc replaceToEmpty(s: string, chars: HashSet[char]): string =
  s.multiReplace(chars.mapIt(($it, "")))
proc formatToValidName(s: string, isCapitalize=false): string =
  let words = s.replaceToEmpty("!\\/:*?'\"<>|^_=#-().".toHashSet).mySplit([' '].toHashSet())
  result = words.map(capitalizeAscii).join()
  if result.len > 0 and (isCapitalize == false):
    result[0] = result[0].toLowerAscii()

let contestID = inputUrl.split("/")[4]
let
  contestName = formatToValidName(contestID)
  contestDir = LocalRoot & &"{contestName}/"
if contestID notin problemsByContest:
  discard os.existsOrCreateDir(contestDir)
  for c in TemplateProblemFilePrefixes:
    let
      fileName = &"{c}.nim"
      filePath = &"{contestDir}{fileName}"
    if fileExists(filePath):
      echo &"{filePath} is already exist."
    else:
      var f = open(filePath, mode=fmReadWrite)
      f.write(basecodeText)
      echo &"{filePath} is created."
  echo "create template for realtime contest."
  discard execShellCmd(&"code -r {contestDir}")
  var f = open("tmp__makeContestDir__", mode=fmReadWrite)
  f.write(contestDir)
  quit()
let problemsInContest = problemsByContest[contestID]


discard os.existsOrCreateDir(contestDir)
for p in problemsInContest:
  # echo p
  let pRawIndexChar = p["problem_index"].getStr()
  var x = "ABCDEFG".find(pRawIndexChar)
  if x == -1:
    x = 7
  let indexChar = "ABCDEFGH"[x].toLowerAscii()
  let
    pRawName = p["name"].getStr()
    problemName = indexChar & formatToValidName(pRawName, isCapitalize=true)
  let
    filePath = contestDir & &"{problemName}.nim"

  let tmpFilePath = &"{contestDir}{indexChar}.nim"
  if fileExists(filePath):
    echo &"{filePath} is already exist."
  elif fileExists(tmpFilePath):
    moveFile(tmpFilePath, filePath)
    echo &"{tmpFilePath} is renamed to {filePath}."
  else:
    var f = open(filePath, mode=fmReadWrite)
    f.write(basecodeText)
    echo &"{filePath} is created."

discard execShellCmd(&"code -r {contestDir}")
var f = open("tmp__makeContestDir__", mode=fmReadWrite)
f.write(contestDir)
