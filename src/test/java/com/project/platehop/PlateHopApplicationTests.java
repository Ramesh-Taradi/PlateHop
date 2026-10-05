package com.project.platehop;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class PlateHopApplicationTests {

	@org.springframework.beans.factory.annotation.Autowired
	private com.project.platehop.repository.RestaurantRepository restaurantRepo;

	@org.springframework.beans.factory.annotation.Autowired
	private com.project.platehop.repository.MenuRepository menuRepo;

	@Test
	void contextLoads() {
		org.junit.jupiter.api.Assertions.assertTrue(restaurantRepo.count() >= 5, "Restaurants should be seeded");
		org.junit.jupiter.api.Assertions.assertTrue(menuRepo.count() >= 10, "Menu items should be seeded");
	}

}
