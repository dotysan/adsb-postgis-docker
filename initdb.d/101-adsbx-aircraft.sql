CREATE TABLE aircraft (
    icao TEXT PRIMARY KEY,
    reg TEXT,
    icaotype TEXT,
    year INT,
    manufacturer TEXT,
    model TEXT,
    ownop TEXT,
    faa_pia BOOLEAN,
    faa_ladd BOOLEAN,
    short_type TEXT,
    mil BOOLEAN
);
