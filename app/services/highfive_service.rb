module HighfiveService
  class Highfive
    include SlackClient

    def initialize(slack_team, sender, recipient, reason, amount = nil)
      @slack_team = slack_team
      @sender = sender
      @recipient = recipient
      @reason = reason
      @amount = amount
    end

    def message
      if slack_sender.id == slack_recipient.id
        self_rebuke
      else
        success
      end
    end

    def valid?
      slack_sender.id != slack_recipient.id
    end

    def commit!
      if valid?
        @record = HighfiveRecord.create! slack_team_id: @slack_team.id, from: slack_sender.id, to: slack_recipient.id, reason: @reason
        GoogleTracker.event category: 'highfive', action: 'sent'
      end
    end

    private

    def slack_users_list
      @slack_users_list ||= slack_client(team_id: @slack_team.team_id).users_list.members
    end

    def slack_sender
      slack_users_list.find { |u| @sender.in? [u.id, u.name] }
    end

    def slack_recipient
      slack_users_list.find { |u| @recipient.in? [u.id, u.name] }
    end

    def success
      {
        response_type: 'in_channel',
        text: "<!channel> <@#{slack_sender.id}> is high-fiving <@#{slack_recipient.id}> for #{@reason} " \
              "<#{random_gif}|:hand:>"
      }
    end

    def self_rebuke
      { text: 'High-fiving yourself is just clapping.' }
    end

    def random_gif
      GIFS.sample
    end
  end

  GIFS = [
    'http://i.giphy.com/zl170rmVMCpEY.gif',
    'http://i.giphy.com/yoJC2vEwxkwbMZmSCk.gif',
    'http://i.giphy.com/Qh5dZDCFqr1dK.gif',
    'http://i.giphy.com/GCLlQnV7wzKLu.gif',
    'http://i.giphy.com/MhHXeM4SpKrpC.gif',
    'http://i.giphy.com/Z7bxVQl7nWes.gif',
    'http://i.giphy.com/ns8SCo6O6g7nO.gif',
    'http://a.fod4.com/images/GifGuide/dancing/280sw007883.gif',
    'http://a.fod4.com/images/GifGuide/dancing/pr2.gif',
    'http://0.media.collegehumor.cvcdn.com/46/28/291cb0abc0c99142aace1353dc12b755-car-race-high-five.gif',
    'http://2.media.collegehumor.cvcdn.com/75/26/b31d5b98a4a27537d075960b7b247773-giant-high-five-from-jackass.gif',
    'http://2.media.collegehumor.cvcdn.com/84/67/ff88c44dec5f9c2747e30549a375d481-bear-high-five.gif',
    'http://0.media.collegehumor.cvcdn.com/17/53/30709bc3c9b060baf771c0b2e2626f95-snow-white-high-five.gif',
    'http://i.giphy.com/p3LmvxiO6noGc.gif',
    'http://i.giphy.com/DYvroxifyHEmA.gif',
    'http://i.giphy.com/kolvlRnXh8Jj2.gif',
    'http://i.giphy.com/tX5iDEX1n1Xxe.gif',
    'http://i.giphy.com/xeXEpUVvAxCV2.gif',
    'http://i.giphy.com/UkhHIZ37IDRGo.gif',
    'http://a.fod4.com/images/GifGuide/dancing/163563561.gif',
    'http://i.giphy.com/mEOjrcTumos80.gif',
    'http://i.giphy.com/99dauSQPLUuIg.gif',
    'http://i.giphy.com/3HICMfLGqgWRy.gif',
    'http://i.giphy.com/GYU7rBEQtBGfe.gif',
    'http://i.giphy.com/vXEeRBP3QeJ2w.gif',
    'http://i.giphy.com/Cj3Ce7e8h2EKY.gif',
    'http://i.giphy.com/3Xtt7hlXvUTvi.gif',
    'http://i.giphy.com/1453cgfKvRLMyc.gif',
    'http://i.giphy.com/WdxAL8nmOCQ5a.gif',
    'http://a.fod4.com/images/GifGuide/dancing/tumblr_llatbbCeky1qbnthu.gif',
    'http://i.giphy.com/FrDlVZMD96nzG.gif',
    'http://i.giphy.com/lcYFNTaz4U9jy.gif',
    'http://i.giphy.com/Dwu7IpRyVA5Nu.gif',
    'http://i.giphy.com/JQNM4AgN7lFUA.gif',
    'http://i.giphy.com/9MGNxEMdWB2tq.gif',
    'http://i.giphy.com/V5VZ64VJp1neo.gif',
    'http://i.giphy.com/LdnaND03GRE9q.gif',
    'http://i.giphy.com/2FazevvcDdyrf1E7C.gif',
    'http://i.giphy.com/il5XqHUQxAdVe.gif',
    'http://i.giphy.com/2AlVpRyjAAN2.gif',
    'http://i.giphy.com/r2BtghAUTmpP2.gif',
    'http://persephonemagazine.com/wp-content/uploads/2013/02/borat-letterman-high-five.gif',
    'http://i.giphy.com/10ThjPOApliaSA.gif',
    'http://i.giphy.com/14rRtgywkOitDa.gif',
    'http://i.giphy.com/rM9Cl7MZphBqU.gif',
    'http://i.giphy.com/t8JeALG3O5SPS.gif',
    'http://i.giphy.com/rSCVJasn8uZP2.gif',
    'http://i.giphy.com/10LKovKon8DENq.gif',
    'http://i.giphy.com/M9TuBZs3LIQz6.gif',
    'http://i.giphy.com/Ch7el3epcW3Wo.gif',
    'http://i.giphy.com/1HPzxMBCTvjMs.gif',
    'http://i.giphy.com/BP9eSu9cnnGN2.gif',
    'http://i.giphy.com/vuFJaBLVTtnZS.gif',
    'http://i.giphy.com/PTJGTImkgRycU.gif',
    'http://i.giphy.com/l41lHvfYqxWus1oYw.gif',
    'http://i.giphy.com/xIhGpmuVtuEpi.gif',
    'http://www.reactiongifs.com/wp-content/uploads/2013/09/bb-high-five.gif',
    'http://www.reactiongifs.com/r/tghf.gif',
    'http://www.reactiongifs.com/wp-content/uploads/2013/05/fallingfan.gif',
    'http://www.reactiongifs.com/wp-content/uploads/2012/11/high-fives.gif',
    'http://www.reactiongifs.com/r/bbb.gif',
    'http://www.reactiongifs.com/wp-content/uploads/2013/02/what-up.gif',
    'http://forgifs.com/gallery/d/241345-4/Bengal-cat-high-five-attack.gif',
    'http://forgifs.com/gallery/d/228874-2/Bowling-high-five-slap-KO.gif',
    'http://forgifs.com/gallery/d/230104-2/Kid-steals-high-five.gif',
    'http://forgifs.com/gallery/d/181670-4/Child-weightlifter-amped.gif',
    'https://media.giphy.com/media/2r04CWsFWwixW/giphy.gif',
  ].freeze
end
