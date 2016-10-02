class Highfive
  def initialize(sender, recipient, reason, amount = nil)
    @sender = sender
    @recipient = recipient
    @reason = reason
    @amount = amount
  end
end
