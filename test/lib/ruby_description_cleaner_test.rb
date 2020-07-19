# frozen_string_literal: true

require "test_helper"

class RubyDescriptionCleanerTest < ActiveSupport::TestCase
  test "simple class" do
    input = <<-HTML
      <p>Appends the given object to <em>str</em>. If the object is an <a href="Integer.html"><code>Integer</code></a>, it is considered a codepoint and converted to a character before being appended.</p>
    HTML

    output = <<-HTML
      <p>Appends the given object to <em>str</em>. If the object is an <a href="/2.4/o/integer"><code>Integer</code></a>, it is considered a codepoint and converted to a character before being appended.</p>
    HTML

    assert_equal RubyDescriptionCleaner.clean("2.4", "String", input), output
  end

  test "deep nesting class" do
    input = <<-HTML
      <p>An instance of <a href="../../OpenSSL/X509/Certificate.html"><code>OpenSSL::X509::Certificate</code></a>.  If this is not provided, then a generic X509 is generated, with a correspond :SSLPrivateKey</p>
    HTML

    output = <<-HTML
      <p>An instance of <a href="/2.3/o/openssl/x509/certificate"><code>OpenSSL::X509::Certificate</code></a>.  If this is not provided, then a generic X509 is generated, with a correspond :SSLPrivateKey</p>
    HTML

    assert_equal RubyDescriptionCleaner.clean("2.3", "DRb::DRbSSLSocket::SSLConfig", input), output
  end

  test "invalid URI" do
    input = <<-HTML
      <p>If <a href=":ssl">options</a> is true, then an attempt will be made to use SSL (now TLS) to connect to the server.  For this to work <a href="../OpenSSL.html"><code>OpenSSL</code></a> [OSSL] and the Ruby <a href="../OpenSSL.html"><code>OpenSSL</code></a> [RSSL] extensions need to be installed.  If <a href=":ssl">options</a> is a hash, it&#39;s passed to <a href="../OpenSSL/SSL/SSLContext.html#method-i-set_params"><code>OpenSSL::SSL::SSLContext#set_params</code></a> as parameters.</p>
    HTML

    output = <<-HTML
      <p>If options is true, then an attempt will be made to use SSL (now TLS) to connect to the server.  For this to work <a href="/2.6/o/openssl"><code>OpenSSL</code></a> [OSSL] and the Ruby <a href="/2.6/o/openssl"><code>OpenSSL</code></a> [RSSL] extensions need to be installed.  If options is a hash, it's passed to <a href="/2.6/o/openssl/ssl/sslcontext#method-i-set_params"><code>OpenSSL::SSL::SSLContext#set_params</code></a> as parameters.</p>
    HTML

    capture_io do
      assert_equal RubyDescriptionCleaner.clean("2.6", "Net::FTP", input), output
    end
  end

  test "doubled up quotes" do
    # This is real HTML from RDoc. Note the quotes in <a href=""EXISTS"">.
    input = <<-HTML
      <p>After you have selected a mailbox, you may retrieve the number of items in that mailbox from @<a href=""EXISTS"">responses</a>[-1], and the number of recent messages from @<a href=""RECENT"">responses</a>[-1]. Note that these values can change if new messages arrive during a session; see <a href="IMAP.html#method-i-add_response_handler"><code>add_response_handler()</code></a> for a way of detecting this event.</p>
    HTML

    output = <<-HTML
      <p>After you have selected a mailbox, you may retrieve the number of items in that mailbox from @responses[-1], and the number of recent messages from @responses[-1]. Note that these values can change if new messages arrive during a session; see <a href="/2.7/o/imap#method-i-add_response_handler"><code>add_response_handler()</code></a> for a way of detecting this event.</p>
    HTML

    capture_io do
      assert_equal RubyDescriptionCleaner.clean("2.7", "IMAP", input), output
    end
  end

  test "unparsable HTML" do
    input = <<-HTML
      <p>s*(((([“‘]).*?<a href=”^/’“>”>5)|</a>*)*?)(/)?&gt;/um, true)</p>
    HTML

    # This needs to be fixed in RDoc
    # https://github.com/ruby/rdoc/issues/763
    output = input

    capture_io do
      assert_equal RubyDescriptionCleaner.clean("2.4", "REXML::DTD::ElementDecl", input), output
    end
  end
end
