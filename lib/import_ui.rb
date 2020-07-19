require "tty-spinner"
require "pastel"

module ImportUI
  @@spinner = nil

  def self.reset
    @@spinner = nil
  end

  def self.start(message)
    @@spinner ||= TTY::Spinner.new(message)
    @@spinner&.auto_spin
  end

  def self.finish(message = "")
    @@spinner&.success(message)
  end

  def self.error(message)
    @@spinner&.error(message)
  end

  def self.clear_line
    @@spinner&.clear_line
  end

  def self.info(message)
    clear_line
    puts message
  end

  def self.warn(message)
    clear_line
    puts color.yellow message
  end

  def self.color
    @@color ||= Pastel.new
  end
end
