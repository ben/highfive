class SlackMessages
  def self.success_gif(record)
    text =
      "<!channel> <@#{record.from}> is `/highfive`ing <@#{record.to}> for #{record.reason}! " \
      "<#{GIFS.sample}|:hand:> "
    if record.amount.present?
      text << "\nA #{record.amount.to_s(:currency)} gift card is on its way!"
    end
    {
      response_type: 'in_channel',
      text: text
    }
  end

  def self.please_confirm(record)
    {
      response_type: 'ephemeral',
      text: "I'm about to send a #{record.amount.to_s(:currency)} gift card to <@#{record.to}>.",
      attachments: [{
        text: 'Please confirm:',
        fallback: "Whoops, you can't confirm right now.",
        attachment_type: 'default',
        callback_id: record.id,
        actions: [
          { name: 'confirm', type: 'button', text: 'Send it!', value: 'yes', style: 'primary' },
          { name: 'confirm', type: 'button', text: 'Never mind', value: 'no' },
        ]
      }]
    }
  end

  def self.confirmed
    {
      response_type: 'ephemeral',
      text: ':+1: On it!'
    }
  end

  def self.canceled
    {
      response_type: 'ephemeral',
      text: ':disappointed: ok'
    }
  end

  def self.no_self_five
    {
      response_type: 'ephemeral',
      text: 'High-fiving yourself is just clapping.'
    }
  end

  def self.no_bots
    {
      response_type: 'ephemeral',
      text: "Don't high-five bots, you'll break your hand."
    }
  end

  def self.cards_not_enabled
    {
      response_type: 'ephemeral',
      text: "Sorry, sending cards is not enabled for this account."
    }
  end

  def self.invalid_amount(record)
    {
      response_type: 'ephemeral',
      text: "Sorry, I can't send a gift card for #{record.amount.to_s(:currency)}."
    }
  end

  def self.too_large(record, team)
    {
      response_type: 'ephemeral',
      text: "I can't send cards for more than #{team.award_limit.to_s(:currency)}."
    }
  end

  def self.over_daily_limit(record, team)
    {
      response_type: 'ephemeral',
      text: "The daily limit for gift cards is #{team.daily_limit.to_s(:currency)}, and the total so far is #{team.daily_total.format(:currency)}."
    }
  end

  def self.invalid_amount(record)
    {
      response_type: 'ephemeral',
      text: "Sorry, I can't send a gift card for #{record.amount.to_s(:currency)}."
    }
  end

  def self.error
    {
      response_type: 'ephemeral',
      text: "Whoops, an error occurred. Maybe try again?"
    }
  end

  def self.funding_failed
    # TODO: give admin contact info
    {
      response_type: 'ephemeral',
      text: "Whoops, I couldn't fund your account. Contact *(TODO)* to figure out what's up."
    }
  end

  def self.unrecognized
    {
      response_type: 'ephemeral',
      text: "Hmm, I couldn't understand that. Try `/highfive @user for (reason)`."
    }
  end

  def self.usage(cards_enabled = false)
    card_suffix = cards_enabled ? "\nTo include a gift card, do `/highfive @user $5 for (reason)`." : ''
    {
      response_type: 'ephemeral',
      text: "To send a highfive, use `/highfive @user for (reason)`.#{card_suffix}"
    }
  end

  def self.stats_link
    {
      response_type: 'ephemeral',
      text: "Visit the <#{ENV['HOSTNAME']}/admin|Highfive site> for info on your team's activity."
    }
  end

  def self.help
    {
      response_type: 'ephemeral',
      text: "Visit the <#{ENV['HOSTNAME']}/admin|Highfive site> for info on your team's activity."
    }
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
