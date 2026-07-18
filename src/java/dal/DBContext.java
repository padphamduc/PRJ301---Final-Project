package dal;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            Properties properties = new Properties();
            // Load resource via classloader (try root and relative package path)
            InputStream is = getClass().getClassLoader().getResourceAsStream("ConnectDB.properties");
            if (is == null) {
                is = getClass().getClassLoader().getResourceAsStream("../ConnectDB.properties");
            }
            if (is == null) {
                is = getClass().getResourceAsStream("/ConnectDB.properties");
            }
            
            if (is != null) {
                properties.load(is);
                String user = properties.getProperty("userID");
                String pass = properties.getProperty("password");
                String url = properties.getProperty("url");
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                connection = DriverManager.getConnection(url, user, pass);
            } else {
                System.err.println("DBContext: Cannot find ConnectDB.properties file.");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}