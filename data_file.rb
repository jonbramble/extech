
class DataFile
 include Serialbar::Adapter
 configure_adapter :mongoid
 field :time
 field :temp
 field :experiment
 store_in session: "default"
end

class TPoint < DataFile

end
