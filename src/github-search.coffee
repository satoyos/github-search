# Description
#   A hubot script that search GitHub repsitories
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot search repo <文字列> - GitHubのレポジトリで、最もスターの多いものを検索
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Yoshifumi sato <sato_yos@nifty.com>

module.exports = (robot) ->
  robot.respond /search\s+repo\s+(.+)$/, (res) ->
    # respondメソッドの正規表現にマッチした文字列からクエリ文字列を取り出す
    query = res.match[1]
    robot
    # リクエスト先のURLを組み立てる
    .http("https://api.github.com/search/repositories?q=#{encodeURIComponent query}&sort=stars&order=desc&per_page=1")
    # getメソッドの戻り値は、実行時、リクエストが送信され、
    # レスポンスが引数の関数にコールバックする。
    .get() (err, httpRes, body)->
      # bodyは文字列、JSONパースを行う。
      json = try JSON.parse body
      # 正しくJSONがパースできると、直下にitemsというキーで配列があるので、
      # その一つ目を検索結果とする。
      repo = json?.items?[0]
      unless repo
        res.reply "`#{query}`に該当するリポジトリが見つかりませんでした。"
        return

      # レスポンスオブジェクトからプロパティを取り出す
      {html_url, stargazers_count, full_name} = repo
      # ユーザに replyメソッドでメッセージを応答する。
      res.reply """
      #{full_name} (#{stargazers_count} :star:)
      #{html_url}
      """
