package KQuest.matlab;

import com.jamal.JamalException;
import com.jamal.client.MatlabClient;

public class KQuestMatlabClient extends MatlabClient {

    private static volatile KQuestMatlabClient client;
    private boolean isShutDown;

    private KQuestMatlabClient() throws JamalException {
        super();
        this.isShutDown = false;
    }

    public static MatlabClient getMatlabClient() throws JamalException {
        if (client == null || client.isShutDown()) {
            client = new KQuestMatlabClient();
        }
        return client;
    }

    public boolean isShutDown() {
        return this.isShutDown;
    }

    @Override
    public Object[] executeMatlabFunction(String matlabFunctionName,
            Object[] inputArgs, int numberOfOutputArgs) throws JamalException {
        if (! this.isShutDown()) {
            return super.executeMatlabFunction(matlabFunctionName,
                    inputArgs, numberOfOutputArgs);
        } else {
            throw new JamalException("This Matlab server is shut down.");
        }
    }

    @Override
    public void shutDownServer() throws JamalException {
        super.shutDownServer();
        this.isShutDown = true;
    }
}
