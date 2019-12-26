package poc;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;


import java.util.Date;

public class TestLambda implements RequestHandler<InputObject, OutputObject>{
    public OutputObject handleRequest(InputObject event, Context context) {

        long currentTime = (new Date()).getTime();
        long apiEpochTime = event.getRequestContext()
                                    .getRequestTimeEpoch();
        String rsBody = "Java Test Lambda took " + (currentTime - apiEpochTime) + "ms to start";

        System.out.println(rsBody);
        return new OutputObject(200, rsBody);
    }
}
