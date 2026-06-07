package com.spacegame.entity;

public class CrewBase {
    private Integer id;
    private String name;
    private Integer rarity;
    private String description;
    private String icon;
    private Integer supplyItemId;
    private Integer fatigueMax;

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

    public Integer getRarity() {
        return rarity;
    }

    public void setRarity(Integer rarity) {
        this.rarity = rarity;
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

    public Integer getSupplyItemId() {
        return supplyItemId;
    }

    public void setSupplyItemId(Integer supplyItemId) {
        this.supplyItemId = supplyItemId;
    }

    public Integer getFatigueMax() {
        return fatigueMax;
    }

    public void setFatigueMax(Integer fatigueMax) {
        this.fatigueMax = fatigueMax;
    }
}