package KQuest.database.entities;

public interface KQuestEntity<PrimaryKey> extends AbstractEntity{
    PrimaryKey getPrimaryKey();
}
