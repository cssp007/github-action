FROM dhiway/cord:develop
ARG KEY=0
COPY ./cord/scripts/node$KEY.key /cord/
COPY ./cord/scripts/accounts.txt /cord/
COPY ./cord/scripts/cssp-raw-spec.json /cord/