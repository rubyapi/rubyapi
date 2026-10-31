# frozen_string_literal: true

class Thread
  class Queue
    def pop
    end

    alias shift pop
  end
end
