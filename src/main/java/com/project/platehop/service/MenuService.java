package com.project.platehop.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.project.platehop.model.Menu;
import com.project.platehop.repository.MenuRepository;

@Service
public class MenuService {

    @Autowired
    private MenuRepository menuRepository;

    public Menu addMenu(Menu menu) {
        return menuRepository.save(menu);
    }

    public List<Menu> getAllMenus() {
        return menuRepository.findAll();
    }

    public List<Menu> getMenusByRestaurant(int restaurantId) {
        return menuRepository.findByRestaurantId(restaurantId);
    }

    public List<Menu> getMenusByRestaurantId(int restaurantId) {
        return getMenusByRestaurant(restaurantId);
    }

    public List<Menu> getAvailableMenusByRestaurant(int restaurantId) {
        return menuRepository.findByRestaurantIdAndIsAvailable(restaurantId, 1);
    }

    public Menu getMenuById(int id) {
        return menuRepository.findById(id).orElse(null);
    }

    public Menu updateMenu(Menu menu) {
        return menuRepository.save(menu);
    }

    public void deleteMenu(int id) {
        menuRepository.deleteById(id);
    }
}
