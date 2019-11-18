package pokeapi;

import com.intuit.karate.KarateOptions;
import org.junit.Test;
import pokeapi.java.BaseRunner;

@KarateOptions(tags = "@pokemon")
public class PokeApiTest extends BaseRunner {

    @Test
    public void test(){
        testParallel(getClass(), 3);
    }

}
