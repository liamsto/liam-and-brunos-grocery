<%@ page trimDirectiveWhitespaces="true" import="java.sql.*,java.io.*" %><%@ include file="jdbc.jsp" %><%

response.setContentType("image/jpeg");  
String id = request.getParameter("productId");

if (id == null) {
    return;
}

int idVal = -1;
try {
    idVal = Integer.parseInt(id);
} catch (Exception e) {
    out.println("Invalid with id : " + id + " Error: " + e);
    return; 
}

String sql = "SELECT productImage FROM Product WHERE productId = ?";

Connection conn = null;
PreparedStatement stmt = null;
ResultSet rst = null;

try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String user = "sa";
    String password = "304#sa#pw";
    conn = DriverManager.getConnection(url, user, password);

    stmt = conn.prepareStatement(sql);
    stmt.setInt(1, idVal);
    rst = stmt.executeQuery();

    int BUFFER_SIZE = 10000;
    byte[] data = new byte[BUFFER_SIZE];

    if (rst.next()) {
        InputStream istream = rst.getBinaryStream(1);
        OutputStream ostream = response.getOutputStream();
        int count;
        while ((count = istream.read(data, 0, BUFFER_SIZE)) != -1) {
            ostream.write(data, 0, count);

            
        }

        ostream.close();
        istream.close();                    
    }
} catch (SQLException | ClassNotFoundException ex) {
    out.println("Error: " + ex.getMessage());
} finally {
    if (rst != null) try { rst.close(); } catch (SQLException ignored) {}
    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
}
%>
