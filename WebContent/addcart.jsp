<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>

<%
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null) {	
	productList = new HashMap<String, ArrayList<Object>>();
}

String userId = (String) session.getAttribute("authenticatedUser"); // Get the logged-in user
if (userId == null) {
    response.sendRedirect("login.jsp"); // Redirect to login if user is not authenticated
    return;
}

String id = request.getParameter("id"); // Product ID
String name = request.getParameter("name"); // Product Name
String price = request.getParameter("price"); // Product Price
Integer quantity = new Integer(1);

// Update session cart
ArrayList<Object> product = new ArrayList<Object>();
product.add(id);
product.add(name);
product.add(price);
product.add(quantity);

if (productList.containsKey(id)) {
    product = (ArrayList<Object>) productList.get(id);

    if (product.size() < 4 || !(product.get(3) instanceof Integer)) {
        System.out.println("Incomplete or invalid product data for ID: " + id);
        while (product.size() < 4) {
            product.add(0); 
        }
    }

    int curAmount = ((Integer) product.get(3)).intValue();
    product.set(3, curAmount + 1);
} else {
    productList.put(id, product);
}

session.setAttribute("productList", productList);

// Store or update the cart in the database
Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String dbUser = "sa";
    String dbPassword = "304#sa#pw";
    conn = DriverManager.getConnection(url, dbUser, dbPassword);

    String checkCartQuery = "SELECT quantity FROM cart WHERE userId = ? AND productId = ?";
    pstmt = conn.prepareStatement(checkCartQuery);
    pstmt.setString(1, userId);
    pstmt.setString(2, id);
    ResultSet rs = pstmt.executeQuery();

    if (rs.next()) {
        int existingQuantity = rs.getInt("quantity");
        String updateCartQuery = "UPDATE cart SET quantity = ?, price = ? WHERE userId = ? AND productId = ?";
        pstmt = conn.prepareStatement(updateCartQuery);
        pstmt.setInt(1, existingQuantity + quantity);
        pstmt.setBigDecimal(2, new BigDecimal(price));
        pstmt.setString(3, userId);
        pstmt.setString(4, id);
        pstmt.executeUpdate();
    } else {
        String insertCartQuery = "INSERT INTO cart (userId, productId, quantity, price) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(insertCartQuery);
        pstmt.setString(1, userId);
        pstmt.setString(2, id);
        pstmt.setInt(3, quantity);
        pstmt.setBigDecimal(4, new BigDecimal(price));
        pstmt.executeUpdate();
    }

    if (rs != null) rs.close();
} catch (Exception e) {
    out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
} finally {
    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
}
%>

<jsp:forward page="showcart.jsp" />
