# frozen_string_literal: true

module OrdersHelpers
  def place_buy_order(order, stock, user, headers)
    post api_v1_orders_new_path, params: { category: 'buy',
                                           price: order.price,
                                           quantity: order.quantity,
                                           stocks_id: stock.id,
                                           users_id: user.id },
                                 headers:
  end

  def place_invalid_buy_order(order, stock, user, headers)
    post api_v1_orders_new_path, params: { category: 'buy',
                                           price: order.price,
                                           quantity: 123_888,
                                           stocks_id: stock.id,
                                           users_id: user.id },
                                 headers:
  end

  def place_sell_order(order, stock, user, headers)
    post api_v1_orders_new_path, params: { category: 'sell',
                                           price: order.price,
                                           quantity: order.quantity,
                                           stocks_id: stock.id,
                                           users_id: user.id },
                                 headers:
  end

  def fulfill_order_buy!
    orders = Order.placed_buy.where(stocks_id: json['order']['stocks_id'])
    orders.fulfill(json['order']['price'])
    Order.find(json['order']['id'])
  end

  def fulfill_order_sell!
    orders = Order.placed_sell.where(stocks_id: json['order']['stocks_id'])
    orders.fulfill(json['order']['price'])
    Order.find(json['order']['id'])
  end

  def current_order
    Order.find(json['order']['id'])
  end
end
