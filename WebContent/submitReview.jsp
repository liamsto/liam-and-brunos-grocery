<%@ page import="java.sql.*" %>
<%
    // Retrieve form values
    String rating = request.getParameter("rating");
    String reviewComment = request.getParameter("review");
    String productId = request.getParameter("productId");

    // Validate inputs
    if (rating == null || reviewComment == null || productId == null ||
        rating.isEmpty() || reviewComment.isEmpty() || productId.isEmpty()) {
        response.sendRedirect("product.jsp?message=poop");
        return;
    }

    // Database connection parameters
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String user = "sa";
    String password = "304#sa#pw";

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Load database driver for SQL Server
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        // Establish connection
        conn = DriverManager.getConnection(url, user, password);

        // SQL Insert query
        String sql = "INSERT INTO review (reviewRating, reviewDate, productId, reviewComment) " +
                     "VALUES (?, GETDATE(), ?, ?)";

        // Prepare statement
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(rating));
        pstmt.setInt(2, Integer.parseInt(productId)); // Updated index
        pstmt.setString(3, reviewComment); // Updated index

        // Execute update
        int rowsInserted = pstmt.executeUpdate();

        if (rowsInserted > 0) {
            response.sendRedirect("product.jsp?message=Thank%20you%20for%20your%20review!");
        } else {
            response.sendRedirect("product.jsp?message=Failed%20to%20submit%20your%20review.");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("product.jsp?message=An%20error%20occurred:%20" + e.getMessage());
    } finally {
        // Close resources
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
