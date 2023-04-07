class BatchStockQuoteJob
  include Sidekiq::Job

  SPACES_LENGTH = 10
  BATCH_QUOTE_LIMIT = 10 # 600

  def perform
    start_time = print_start
    p "  First #{BATCH_QUOTE_LIMIT} stocks"

    quotes = iex_latest_price
    print_headers
    execute_orders(quotes)
    print_elapsed(start_time)
  end

  def affected_orders(stocks_id)
    Order.placed_buy.where(stocks_id:)
  end

  def execute_orders(stocks)
    stocks.each do |stock|
      stocks_id = Stock.find_id_by_ticker(stock['symbol'])
      price = stock['latestPrice']

      buy_orders, sell_orders = fulfill_orders(stocks_id, price)

      print_rows([stocks_id, stock['symbol'], buy_orders.length, sell_orders.length, stock['latestPrice']])
    end
  end

  def fulfill_orders(stocks_id, price)
    buy_orders = Order.placed_buy.where(stocks_id:)
    buy_orders.fulfill(price)

    sell_orders = Order.placed_sell.where(stocks_id:)
    sell_orders.fulfill(price)

    [buy_orders, sell_orders]
  end

  def iex_latest_price
    batch = Stock.quote_all(BATCH_QUOTE_LIMIT)
    batch.reject { |stock| stock['latestPrice'].nil? }
  end

  def print_start
    p '------------------------------------------'
    p "  start: #{Time.now}"
    Time.now
  end

  def print_elapsed(start_time)
    p "  Elapsed: #{Time.now - start_time}"
    p '------------------------------------------'
  end

  def print_headers
    p '               STOCKS               |     ORDERS     |'
    p '  id    |  symbol  |  latest_price  |  buy  |  sell  |'
  end

  def print_rows(arr)
    p '  ' + arr[0].to_s.ljust(4) + '  |  ' + arr[1].ljust(6) + '  |  ' +
             arr[4].to_s.rjust(12) + '  |  ' + arr[2].to_s.rjust(3) + '  |  ' +
             arr[3].to_s.rjust(4) + '  |'
  end

  def print
    start_time = Time.now
    p '------------------------------------------'
    p "  start: #{Time.now}"
    p '  First 500 stocks'

    nil_stock_counter = 0
    batch = Stock.quote_all(600)
    batch.each do |ticker|
      # p ['', ticker['symbol'], '', ticker['latestPrice']].join("\t")
      nil_stock_counter += 1 if ticker['latestPrice'].nil?
      gap = ' ' * (SPACES_LENGTH - ticker['symbol'].length)
      p "  #{ticker['symbol']}#{gap}#{ticker['latestPrice']}"
    end

    p "  Total nil stock: #{nil_stock_counter}"
    p "  Elapsed: #{Time.now - start_time}"
    p '------------------------------------------'
  end
end
