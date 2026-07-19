package dal;

import java.util.ArrayList;
import java.util.List;
import model.Service;

/** Service DAO skeleton. */
public class ServiceDAO extends DBContext {

    public List<Service> getAllServices() {
        // TODO MEMBER 1/2/3: shared read method.
        return new ArrayList<>();
    }

    public Service getServiceById(int id) {
        // TODO MEMBER 4.
        return null;
    }

    public boolean addService(Service service) {
        // TODO MEMBER 4.
        return false;
    }

    public boolean updateService(Service service) {
        // TODO MEMBER 4.
        return false;
    }

    public boolean deleteService(int id) {
        // TODO MEMBER 4.
        return false;
    }
}
