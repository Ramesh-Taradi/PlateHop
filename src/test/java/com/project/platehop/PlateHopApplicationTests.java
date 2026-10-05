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
		org.junit.jupiter.api.Assertions.assertTrue(restaurantRepo.count() >= 20, "Should have at least 20 restaurants seeded");
	}

}
