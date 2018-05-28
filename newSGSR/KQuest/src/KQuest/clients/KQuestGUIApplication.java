package KQuest.clients;

import KQuest.GUI.KQuestApplicationView;
import java.awt.Window;
import org.jdesktop.application.Application;
import org.jdesktop.application.SingleFrameApplication;

/**
 * The main class of the application.
 */
public class KQuestGUIApplication extends SingleFrameApplication {

    /**
     * At startup create and show the main frame of the application.
     */
    @Override protected void startup() {
        show(KQuestApplicationView.initInstance(this));
    }

    /**
     * This method is to initialise the specified window by injecting resources.
     * Windows shown in our application come fully initialised from the GUI
     * builder, so this additional configuration is not needed.
     */
    @Override protected void configureWindow(final Window root) {
    }

    /**
     * A convenient static getter for the application instance.
     * @return the instance of KQuestGUIApplication
     */
    public static KQuestGUIApplication getApplication() {
        return Application.getInstance(KQuestGUIApplication.class);
    }

    /**
     * Main method launching the application.
     */
    public static void main(final String[] args) {
        launch(KQuestGUIApplication.class, args);
    }
}
