use FoodStore

go

select * from IceCream

go
--9)
create trigger DeleteOrdersUpdateCount
on orders
after delete
as begin 
	update IceCream
	set IceCream.StockQuantity = StockQuantity+deleted.Quantity  
	from IceCream
	join OrderHistory on IceCream.id = OrderHistory.IceCreamId
	join deleted on OrderHistory.orderId = deleted.id
	where IceCream.id = OrderHistory.IceCreamId
end;

go

--8)
create trigger UpdateCountAfterOrder
on OrderHistory
after insert
as begin
    update IceCream
    set StockQuantity = StockQuantity - inserted.Quantity
    from IceCream
    join inserted on IceCream.id = inserted.IceCreamId
end



go
--7)
create trigger DeleteOrderHistory
on orders
after insert,update
as 
begin
	delete OrderHistory from OrderHistory
	join orders on OrderHistory.orderId = orders.id
	where DATEDIFF(MONTH,orders.OrderDate,GETDATE()) >= 6
end
	
go
--2)

create trigger TotalCostByOrder
on OrderHistory
after insert,update
as 
begin
	update orders
	set orders.TotalCost = (select sum(IceCream.Price * OrderHistory.Quantity)
		from OrderHistory
		join IceCream on OrderHistory.IceCreamId =IceCream.id
		where OrderHistory.orderId = orders.id)
	from orders
	join inserted on orders.id =inserted.orderId
end

go