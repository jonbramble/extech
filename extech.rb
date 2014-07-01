require 'serialbar'
require 'awesome_print'

class DataFile
 include Serialbar::Adapter
 configure_adapter :mongoid
 field :experiment
 store_in session: "default"
end

class TPoint < DataFile
  field :time
  field :ambient
  field :temp
end

class Listener
 include Serialbar::Listener

 def parse(string)	
    tm = Time.now
    experiment = "POLFE00X"

    ambient = string.byteslice(7, 4).to_i(16).fdiv(10).to_s
    temp = string.byteslice(1, 4).to_i(16).fdiv(10).to_s
    str = {time: tm, temp: temp, ambient: ambient, experiment: experiment}
    #save_temp_to_db(str) 
    print_string(str)
 end

 def print_string(str)
    ap str
 end

 def save_temp_to_db(data)
  data_point = TPoint.new(data)
  data_point.save
 end

end

l = Listener.new
l.setup("/dev/ttyS0",2400,7,1,1)
l.serial_port.write("%EEER\n")

l.serial_port.readline    # captures initial reply from logger

l.poll_every_n_seconds("#001N\n",5)




