require 'serialbar'
require_relative 'data_file'

class Listener
	include Serialbar::Listener

	def parse(string)
	 tm = Time.now
    	 experiment = "MHT000X"

	 temp = string.byteslice(1, 4).to_i(16).fdiv(10).to_s
    	 str = {time: tm, temp: temp, experiment: experiment}
    	 save_temp_to_db(str)
         ap str
	end

	def save_temp_to_db(data)
  	  data_point = TPoint.new(data)
  	  data_point.save
 	end
end


ln = Listener.new
ln.setup("/dev/ttyS0",2400,7,1,2)
ln.poll_every_n_seconds("#001N\n",lines=1,n=5)
