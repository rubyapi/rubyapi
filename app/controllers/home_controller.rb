# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :enable_public_cache

  def index
    @tiles = [
      Tile.new("Core",
        "The main building blocks for Ruby.",
        %w[
          BasicObject
          Binding
          Class
          Kernel
          Method
          Module
          Object
          Proc
      ]),
      Tile.new("Basic Types",
        "Basic types are used for numbers, text, booleans, etc.",
        %w[
          BigDecimal
          Complex
          Date
          DateTime
          FalseClass
          Float
          NilClass
          Numeric
          Rational
          Regexp
          String
          Struct
          Symbol
          Time
          TrueClass
      ]),
      Tile.new("Collections",
        "Collections group multiple elements together.",
        %w[
          Array
          Enumerable
          Enumerator
          Hash
          Range
          Set
      ]),
      Tile.new("FileSystem and IO",
        "Open and read files, or make system calls.",
        %w[
          Dir
          File
          File::Stat
          FileTest
          FileUtils
          Find
          IO
          Open3
          Pathname
          StringIO
          Tempfile
          Zlib
      ]),
      Tile.new("IO and System",
        "Open and read files, or make system calls.",
        %w[
          Etc
          OptionParser
          PTY
          Process
          Readline
          Shellwords
          Signal
          Syslog
      ]),
      Tile.new("Networking",
        "Create client/server programs.",
        %w[
          CGI
          DRb
          IPAddr
          IPSocket
          OpenURI
          Net::HTTP
          Resolv
          Socket
          TCPServer
          TCPSocket
          UDPSocket
          UNIXServer
          UNIXSocket
          URI
      ]),
      Tile.new("Serialization",
        "Read and write data in other formats.",
        %w[
          CSV
          JSON
          Marshal
          YAML
      ]),
      Tile.new("Concurrency and Parallelism",
        "Make Ruby code run at the same time.",
        %w[
          Fiber
          Monitor
          Mutex_m
          Ractor
          Thread
          Thread::ConditionVariable
          Thread::Mutex
          Thread::Queue
          Thread::SizedQueue
          ThreadGroup
      ]),
      Tile.new("Introspection",
        "Get information about your Ruby code during runtime.",
        %w[
          Benchmark
          GC
          Logger
          PP
          PrettyPrint
          ObjectSpace
          TracePoint
          WeakRef
        ])
    ]
  end
end
