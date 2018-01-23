- Set up production environment
  - Create heroku app
  - DNS
  - Add to pipeline
  - Configure
    - https://api.slack.com/apps/A2JECFRN3
- https://highfive.chat/privacy
- https://highfive.chat/support
- [help@highfive.chat](mailto:help@highfive.chat)
  - Set up MX through G Suite
  - Connect Inbox account
- [Twitter card][tc] / [OpenGraph][og] for home view
- [Tangocard][tango] integration

[tc]: https://dev.twitter.com/cards/overview
[og]: http://ogp.me/
[tango]: https://integration-www.tangocard.com/raas_api_console/v2/#/

- `initial`
- `waiting_on_confirmation`

command post: set to "initial", trigger first processing
initial: has no amount? replace with in_channel hi5, set state to "sent"
initial: fails settings check? reply with ephemeral warning, set state to "invalid"
initial: passes settings check? reply with confirmation buttons, set state to "confirm"
confirm (interaction): canceled? send "fine", set state to "canceled"
confirm (interaction): confirmed? ephemeral 👍🏼, queue tango job, set state to "queued"
(tango job) queued: funding failed? reply with "funding failed", set state to "failed"
(tango job) queued: funded, sending failed? reply with "failure", set state to "failed"
(tango job) queued: sending succeeded? broadcast gif, set state to "sent"

Admin: filter rows to only "sent", separate view for failed?
