class Mediator
  def initialize seller, buyer   
    @seller = seller   
    @buyer = buyer   
  end  
  def sell   
    @seller.sell   
  end  
  def buy   
    @buyer.buy   
  end  
end  

class  Seller
  def sell;end
end

class Buyer
  def buy;end
end

a = Mediator.new Seller.new, Buyer.new
a.sell
a.buy

