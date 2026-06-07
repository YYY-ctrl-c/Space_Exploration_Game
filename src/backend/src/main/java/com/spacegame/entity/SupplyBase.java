package com.spacegame.entity;

public class SupplyBase {
    private Integer id;
    private String name;
    private String description;
    private Boolean isUniversal; // tinyint(1) 映射为 Boolean
    private String icon;

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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getUniversal() {
        return isUniversal;
    }

    public void setUniversal(Boolean universal) {
        isUniversal = universal;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }
}