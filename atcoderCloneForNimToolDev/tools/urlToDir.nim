# import std/[httpclient, json]

import std/httpclient
var client = newHttpClient()
echo client.getContent("https://kenkoooo.com/atcoder/resources/contests.json")
# var client = newHttpClient()
# echo client.getContent("http://google.com")

# url to problems
# - get json with atcoderProblemsApi

# const ApiContests = "https://kenkoooo.com/atcoder/resources/contests.json"
# const ApiProblems = "https://kenkoooo.com/atcoder/resources/merged-problems.json"
# var client = newHttpClient()
# echo client.request(ApiProblems).status

# echo res.body
# - json to table
# - prepare contestId
# - get problems

# problems to fileNames
# filenames.map(createFileWithBaseCode)
