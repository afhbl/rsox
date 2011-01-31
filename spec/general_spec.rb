require 'rsox'

describe 'general' do
  before :all do
    @rs = RSox.new
  end

  it 'just works' do
    i = @rs.open_read 'file.mp3'
    i.class.to_s.should == 'RSoxFormat'
    i.signal.class.to_s.should == 'RSoxSignal'
  end

  it 'decode mp3 & encode pcm wav' do
    input  = @rs.open_read  'file.mp3'

    sig = input.signal
    sig.bits.should == 16
    sig.channels.should == 2
    sig.channels = 1

    enc = input.encoding
    #enc.bps.should == 320

    output = @rs.open_write 'file.out.mp3', input.signal, input.encoding

    buf = RSoxBuffer.new 4096
    buf.length.should == 4096

    while (readed = input.read buf) > 0
      wrote = output.write buf, readed
      readed.should == wrote
    end

    input.close.should == 0
    output.close.should == 0
  end

  it 'checks buffer' do
    buffer = RSoxBuffer.new
    buffer.length.should == 2048
  end
end