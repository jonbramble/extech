class DataFile
 include Serialbox::Adapter
 configure_adapter :mongoid
 field :time
 field :temp
 field :experiment
 store_in session: "default"
end

class DataPoint < DataFile

end
