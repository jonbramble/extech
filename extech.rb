require 'serialport'
require 'mongoid'
require 'json'
require 'awesome_print'
require 'timers'

class TPoint
  include Mongoid::Document
  field :time
  field :temp
  field :experiment
  store_in session: "default"
end

Mongoid.load!("mongoid.yml", :production)

class SerialListen

 def initialize(port="/dev/ttyS0")
   @portname = port || "/dev/ttyUSB0"
   @sp = SerialPort.new(@portname,2400,7,1,SerialPort::EVEN)
   @sp.write("%EEER\n")
 end

 def parse_input(string)	
    	 tm = Time.now
    	 experiment = "MHT000X"

	 temp = string.byteslice(1, 4).to_i(16).fdiv(10).to_s
    	 str = {time: tm, temperature: temp, experiment: experiment}
    	 save_temp_to_db(str)
    	 ap str
 end

 
 def read
  @sp.write("#001N\n")
  begin
   @sp.readline()
  rescue Interrupt
   puts "Interrupt"
  end
 end

 def run
   puts "Listening on serial port #{@portname}"
    
   @sp.flush_input
   #@sp.write("#001N\n")

   timers = Timers.new

   every_seconds = timers.every(1) { parse_input(read) }
   loop { timers.wait } 

 end

 def save_temp_to_db(data)
  data_point = TPoint.new(data)
  data_point.save
 end

end

listen = SerialListen.new("/dev/ttyS0")
listen.run




