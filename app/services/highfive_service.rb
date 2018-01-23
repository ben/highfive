module HighfiveService
  class Highfive
    include SlackClient
    include SlackRecordOwner

    def initialize(slack_team, record)
      @slack_team = slack_team
      @record = record
    end

    def process!(input = nil)
      new_state, ret = case @record.state
      when 'initial'
        process_initial
      when 'confirm'
        process_confirmation(input)
      when 'queued'
        process_queued
      else
        Rails.logger.warn "Tried to process record #{@record.id} with state #{@record.state}"
        SlackMessages.error
      end
      @record.state = new_state
      @record.save
      ret
    end

    private

    def process_initial
      return 'invalid', SlackMessages.no_self_five if self_five?
      return 'invalid', SlackMessages.no_bots if targeted_at_bot?
      return 'sent', SlackMessages.success_gif(@record) if !@record.amount.present?
      return 'disabled', SlackMessages.cards_not_enabled if !@slack_team.tangocard?
      return 'invalid', SlackMessages.invalid_amount(@record) if invalid_amount?
      return 'invalid', SlackMessages.too_large(@record, slack_team) if too_large?
      return 'invalid', SlackMessages.over_daily_limit(@record, slack_team) if over_daily_limit?
      return 'confirm', SlackMessages.please_confirm(@record)
    end

    def process_confirmation(confirmed)
      # TODO:
    end

    def process_queued
      # TODO:
    end

    def success?
      !(self_five? || targeted_at_bot? || (@amount.present? && !valid_amount?))
    end

    def self_five?
      slack_sender.id == slack_recipient.id
    end

    def targeted_at_bot?
      slack_recipient.is_bot
    end

    def invalid_amount?
      @record.amount.present? && @record.amount <= 0
    end

    def too_large?
      @record.amount > @slack_team.award_limit
    end

    def over_daily_limit?
      @slack_team.daily_total > @slack_team.daily_limit
    end
  end
end
