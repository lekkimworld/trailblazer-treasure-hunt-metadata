({
	onInit: function(cmp, event, helper) {
		
	},
    drawWinner: function(cmp, event, helper) {
        const action = cmp.get("c.getLotteryParticipants");
        action.setParams({
            "recordId": cmp.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var handles = response.getReturnValue();
                cmp.set("v.handles", handles);
                if (handles.length < 3) {
                    cmp.set("v.feedback", "Too few participants to draw winners. Must have at least 3...");
                    return;
                }
                
                // draw winners
                var handle1 = Math.round(Math.random() * (handles.length-1));
                var handle2;
                var handle3;
                do {
                    handle2 = Math.round(Math.random() * (handles.length-1));
                } while (handle1 === handle2);
                do {
                    handle3 = Math.round(Math.random() * (handles.length-1));
                } while (handle1 === handle3 || handle2 === handle3);

                cmp.set("v.handle1", handles[handle1]);
                cmp.set("v.handle2", handles[handle2]);
                cmp.set("v.handle3", handles[handle3]);
                
                const participants = $A.getCallback(() => {
                    cmp.set("v.feedback", `Found ${cmp.get("v.handles").length} participants...`)
                    window.setTimeout($A.getCallback(function() {
                        cmp.set("v.feedback", `The winners are: ${cmp.get("v.handle1")}, ${cmp.get("v.handle2")}, ${cmp.get("v.handle3")}`);
                    }), 2000);
                });
                window.setTimeout(participants, 0);
            }
        });
        $A.enqueueAction(action);
        
    }
})