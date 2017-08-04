function trackPurchase (orderId) {
  var orderId = orderId;

  // Make ajax call to db to retrieve the order. 
  $.ajax({
    method: 'GET',
    url: '/orders/' + orderId + '.json', 
    success: function(res) {
      // Get the order and associated carted products
      var order = res;
      var carted_products = res.carted_products;

      // Loop through each carted product to add product details on Google Analytics
      for(var i = 0; i < carted_products.length; i++) {
        var carted_product = carted_products[i];
        var product = carted_product.product;
        
        ga('ec:addProduct', {
          'id': product.id,
          'name': product.name,
          'category': 'Furniture',
          'brand': 'Rezide',
          'variant': 'black',
          'price': product.price,
          'quantity': carted_product.quantity
        });
      }
      // Send the overall order/purchase data to Google Analytics
      // Transaction level information is provided via an actionFieldObject.
      ga('ec:setAction', 'purchase', {
        'id': order.id,
        'affiliation': 'Rezide',
        'revenue': order.subtotal,
        'tax': order.tax,
        'shipping': '0'
      });

      ga('send', 'pageview');     // Send transaction data with initial pageview.
    },
    error: function(response) {
    }
  })
}