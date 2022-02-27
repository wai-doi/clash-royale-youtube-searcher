module BatchSpecHelper
  def suppress_puts
    allow(STDOUT).to receive(:puts)
  end
end
