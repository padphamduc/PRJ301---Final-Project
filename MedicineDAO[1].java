package dal;

import java.util.ArrayList;
import java.util.List;
import model.Medicine;

/** Medicine DAO skeleton. */
public class MedicineDAO extends DBContext {

    public List<Medicine> getAllMedicines() {
        // TODO MEMBER 3/4: doctor selection and admin management.
        return new ArrayList<>();
    }

    public Medicine getMedicineById(int id) {
        // TODO MEMBER 3/4.
        return null;
    }

    public boolean addMedicine(Medicine medicine) {
        // TODO MEMBER 4.
        return false;
    }

    public boolean updateMedicine(Medicine medicine) {
        // TODO MEMBER 4.
        return false;
    }

    public boolean deleteMedicine(int id) {
        // TODO MEMBER 4.
        return false;
    }

    public boolean updateStock(int medicineId, int quantityToSubtract) {
        // TODO MEMBER 4: update stock safely.
        return false;
    }
}
