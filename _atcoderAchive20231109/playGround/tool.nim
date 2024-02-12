import std/[os, sequtils, strutils, httpclient, json, tables, sets]
import zippy # zippyに感謝

const AllProblemUrl = ("https://kenkoooo.com/atcoder/resources/merged-problems.json")
const LocalRoot = "../"

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

proc isValidUrl(url: string): bool =
  url.startsWith("https://atcoder.jp/contests/")
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

var rawInputText = ""
while true:
  rawInputText = stdin.readLine
  if rawInputText.len == 0:
    continue
  if rawInputText.isValidUrl:
    break
  echo "please valid atcoder url."
let inputUrl = rawInputText
let contestID = inputUrl.split("/")[4]
let problemsInContest = problemsByContest[contestID]

discard os.existsOrCreateDir("test")
for p in problemsInContest:
  # echo p
  let pRawIndexChar = p["problem_index"].getStr()
  var x = "ABCDEFG".find(pRawIndexChar)
  if x == -1:
    x = 7
  let indexChar = "ABCDEFGH"[x].toLowerAscii()
  let
    pRawName = p["name"].getStr()
    words = pRawName.replaceToEmpty("\\/:*?\"<>|".toHashSet).mySplit([' '].toHashSet())
    problemName = indexChar & words.map(capitalizeAscii).join()
  echo problemName