# frozen_string_literal: true
require 'observer' # From STDLIB

# This is the actual object.
# It will have observers to be determined
# later on
class Account
  include Observable

  STATES = [
    STATE_NEW = 'new',
    STATE_PAID = 'paid',
    STATE_CANCELLED = 'cancelled'
  ].map(&:freeze).freeze

  attr_reader :state

  def initialize
    @state = STATE_NEW
  end

  STATES.each do |s|
    define_method "#{s}?" do
      @state == s
    end
  end

  def activate!
    @state = STATE_PAID
    changed
    notify_observers(self)
  end

  def cancel!
    @state = STATE_CANCELLED
    changed
    notify_observers(self)
  end
end

# An actual observer class that does one thing
# when the state changes
class AccountantObserver
  def update(account)
    puts 'Accountant just changed his books to charge account' if account.paid?
    puts 'Accountant just changed his books stop charging' if account.cancelled?
  end
end

# An other observer class that does something else
# when the state changes
class ProductObserver
  def update(account)
    puts "Account now has access to product as account is #{account.state}" if account.paid?
    puts "Account #{account.state} revoked its access to product" if account.cancelled?
  end
end

# Create the object
account = Account.new

# Give it a few observers
accountant = AccountantObserver.new
account.add_observer(accountant)
account.add_observer(ProductObserver.new)

# Do stuff with the object
puts 'Activation:'
account.activate!
puts
puts 'Cancellation:'
account.cancel!
