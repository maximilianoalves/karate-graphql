package pokeapi.java;

import com.github.javafaker.Faker;

public class PokemonFaker {

    public static Faker faker = new Faker();

    public static String name() {
        return faker.pokemon().name();
    }

}
