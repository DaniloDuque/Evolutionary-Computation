import java.io.Serializable;
import java.util.*;


public class pair<t1, t2> implements Serializable{

    private static final long serialVersionUID = 1L;
    public t1 first;
    public t2 second;

    public pair(t1 x, t2 y){
        first = x;
        second = y;
    }

    @Override
    public int hashCode() {
        return Objects.hash(first, second);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        pair<?, ?> pair = (pair<?, ?>) obj;
        return Objects.equals(first, pair.first) && Objects.equals(second, pair.second);
    }
    

}