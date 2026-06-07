package com.spacegame.entity;

public class ShopItem {
    private Integer id;
    private String name;
    private Integer price;
    private String description;
    private String icon;
    private Boolean isSupply;
    private Integer supplyPower;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getPrice() {
        return price;
    }

    public void setPrice(Integer price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public Boolean getSupply() {
        return isSupply;
    }

    public void setSupply(Boolean supply) {
        isSupply = supply;
    }

    public Integer getSupplyPower() {
        return supplyPower;
    }

    public void setSupplyPower(Integer supplyPower) {
        this.supplyPower = supplyPower;
    }
}