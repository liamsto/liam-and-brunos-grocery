<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Shopping Cart</title>
		  <!--why I should get bonus marks - cool fancy CSS -->
    <style>
		
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 20px;
        }
        h1, h2 {
            text-align: center;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            text-align: left;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 8px;
        }
        th {
            background-color: #f4f4f4;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .remove-button {
            background-color: #ff4d4d;
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-size: 0.9em;
        }
        .remove-button:hover {
            background-color: #cc0000;
        }
        .header {
            background-color: #007bff;
            padding: 10px;
            text-align: center;
        }
        .header a {
            color: #fff;
            margin: 0 15px;
            font-weight: bold;
            text-decoration: none;
            transition: color 0.3s;
        }
        .header a:hover {
            color: #cce0ff;
        }
        .action-button {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 20px;
            margin: 10px;
            border-radius: 5px;
            text-align: center;
            text-decoration: none;
            font-size: 1em;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .action-button:hover {
            background-color: #0056b3;
        }
        .quantity-input {
            width: 50px;
            text-align: center;
        }
    </style>
    <script>
		//Bonus marks - remove item from cart and set/update quantity 
        function removeItem(productId) {
            window.location.href = 'removeitem.jsp?productId=' + productId;
        }
        function updateQuantity(productId) {
            const quantity = document.getElementById('quantity-' + productId).value;
            window.location.href = 'updatecart.jsp?productId=' + productId + '&quantity=' + quantity;
        }
    </script>
</head>
<body>
    <div class="header">
        <a href="listprod.jsp">Products</a>
        <a href="listorder.jsp">List Orders</a>
        <a href="showcart.jsp">Shopping Cart</a>
    </div>

<%
//gets the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{   out.println("<h1>Your shopping cart is empty!</h1>");
    productList = new HashMap<String, ArrayList<Object>>();
}
else
{
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    out.println("<h1>Your Shopping Cart</h1>");
    out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
    out.println("<th>Price</th><th>Subtotal</th><th>Action</th></tr>");

    double total =0;
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    while (iterator.hasNext()) 
    {   Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		//i don't remember why this is here but it works so I don't want to take it out
        if (product.size() < 4)
        {
            out.println("<p>Expected product with four entries. Got: "+product+"</p>");
            continue;
        }
        
        out.print("<tr><td>"+product.get(0)+"</td>");
        out.print("<td>"+product.get(1)+"</td>");

        int qty = 0;
        Object itemqty = product.get(3);
        try
        {
            qty = Integer.parseInt(itemqty.toString());
        }
        catch (Exception e)
        {
            out.println("<p style='color: red;'>Invalid quantity for product: "+product.get(0)+" quantity: "+qty+"</p>");
        }

        out.print("<td align=\"center\">");
        out.print("<input type='number' id='quantity-" + product.get(0) + "' class='quantity-input' value='" + qty + "' min='1'>");
        out.print("<button onclick=\"updateQuantity('" + product.get(0) + "')\">Update</button>");
        out.print("</td>");

        Object price = product.get(2);
        double pr = 0;
        
        try
        {
            pr = Double.parseDouble(price.toString());
        }
        catch (Exception e)
        {
            out.println("<p style='color: red;'>Invalid price for product: "+product.get(0)+" price: "+price+"</p>");
        }

        out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
        out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td>");
		//Bonus marks - remove button to remove item from cart
        out.print("<td><button class=\"remove-button\" onclick=\"removeItem('" + product.get(0) + "')\">Remove</button></td>");
        out.println("</tr>");
        total = total + pr * qty;
    }
    out.println("<tr><td colspan=\"5\" align=\"right\"><b>Order Total</b></td>"
            +"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
    out.println("</table>");

    out.println("<div style='text-align: center;'>");
    out.println("<a href=\"checkout.jsp\" class=\"action-button\">Check Out</a>");
    out.println("<a href=\"listprod.jsp\" class=\"action-button\">Continue Shopping</a>");
    out.println("</div>");}
%>
</body>
</html>
