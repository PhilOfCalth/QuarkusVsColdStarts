package poc;

import javax.inject.Inject;
import javax.inject.Named;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import java.util.Date;

@Named("test")
public class TestLambda implements RequestHandler<InputObject, OutputObject> {

    public OutputObject handleRequest(final InputObject event, final Context context) {

        final long currentTime = (new Date()).getTime();
        final long apiEpochTime = event.getRequestContext()
                                .getRequestTimeEpoch();
        final String rsBody = event.getPath()
                .substring(1) +
                " Lambda took " +
                (currentTime -
                        apiEpochTime) +
                "ms to start";

        System.out.println(rsBody);
        return new OutputObject(200, rsBody);
    }
}
