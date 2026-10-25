class Lazyssm < Formula
  desc "Terminal UI for AWS SSM Session Manager"
  homepage "https://github.com/chalvinwz/lazyssm"
  url "https://github.com/chalvinwz/lazyssm/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "ca24f3f7633555750811f02ecbc5f5bc8f7ccf3d502ffc87d97c0b5a3cb68f79"
  license "MIT"
  head "https://github.com/chalvinwz/lazyssm.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lazyssm"
  end

  def caveats
    # Casks are macOS-only; on Linux, AWS's page has the plugin's packages.
    plugin = if OS.mac?
      "brew install --cask session-manager-plugin"
    else
      "session-manager-plugin: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html"
    end
    <<~EOS
      lazyssm needs the AWS CLI and the Session Manager plugin at runtime:
        brew install awscli
        #{plugin}

      Run `lazyssm doctor` to check your environment.
    EOS
  end

  test do
    assert_match "lazyssm #{version}", shell_output("#{bin}/lazyssm --version")
  end
end
