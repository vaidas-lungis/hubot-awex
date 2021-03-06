# Description:
#   Interact with AWEX API server
#
# Dependencies:
#   none
#
# Configuration:
#   HUBOT_AWEX_API_URL
#
# Commands:
#   hubot awex ping - test API is responding
#   hubot awex sleep <website> - Sleep website
#   hubot awex wake <website> - Wake website
#
# Author:
#   fordnox

request = require('request')

hostinger_request = (method, url, params, handler) ->
  api_url = process.env.HUBOT_AWEX_API_URL

  request {
    baseUrl: api_url,
    url: url,
    method: method,
    form: params
  },
    (err, res, body) ->
      if err
        console.log "awex says: #{err}"
        return
      console.log "awex: #{url} -> #{body}"

      content = JSON.parse(body)
      if content.error?.message
        console.log "awex error: #{content.error.message}"
        handler "Error: #{body}"
      else
        handler content.result

module.exports = (robot) ->
  robot.respond /awex ping/i, (msg) ->
    hostinger_request 'GET', 'ping', null,
      (result) ->
        msg.send result

  robot.respond /awex sleep ([\S]+)/i, (msg) ->
    website = msg.match[1]
    hostinger_request 'POST', 'apps/' + website + '/sleep',
      {},
      (result) ->
        msg.send result

  robot.respond /awex wake ([\S]+)/i, (msg) ->
    website = msg.match[1]
    hostinger_request 'POST', 'apps/' + website + '/wake',
      {},
      (result) ->
        msg.send result
