# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :enable_public_cache

  def index
    @tiles = [
      Tile.new("Core", %w[
        BasicObject
        Binding
        Class
        Kernel
        Method
        Module
        Object
        Proc
      ]),
      Tile.new("Basic types", %w[
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
      Tile.new("Collections", %w[
        Array
        Enumerable
        Enumerator
        Hash
        Range
        Set
      ]),
      Tile.new("Modules", %w[
        Comparable
        Delegator
        Enumerable
        SimpleDelegator
        SingleForwardable
        Singleton
      ]),

      Tile.new("Networking", %w[
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
      Tile.new("IO and System", %w[
        Dir
        Etc
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
      Tile.new("Concurrency", %w[
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
      Tile.new("Debugging and GC", %w[
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
